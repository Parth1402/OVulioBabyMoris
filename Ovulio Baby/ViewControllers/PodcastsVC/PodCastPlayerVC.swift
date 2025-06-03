//
//  PodCastPlayerVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2024-09-04.
//

import UIKit
import AVFoundation
import Network

class PodCastPlayerVC: UIViewController, ZHWaveformViewDelegate, ZHCroppedDelegate {
    
    var customNavBarView: CustomNavigationBar?
    let podCastImgView = UIImageView()
    let podcastTitleLabel = UILabel()
    let podcastCaptionLabel = UILabel()
    let lblOverallDuration = UILabel()
    let lblcurrentText = UILabel()
    let trackView = UIView()
    let ButtonPlay = UIButton()
    let ButtonBackWard = UIButton()
    let ButtonForward = UIButton()
    let loader = UIActivityIndicatorView(style: .large)
    
    fileprivate let seekDuration: Float64 = 10
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var maxsliderValue:Float = 0.0
    var form: ZHWaveformView?
    
    var comeBackFromArticleAndPlay = false
    var isAudioReadyToPlay = false
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setUpBackground()
        setUpNavigationBar()
        setupUI()
        configAudioPlayer()
        setupLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("viewWillAppear PodCastPlayerVC")
        if !(ProfileDataManager.shared.hasSeenPodcastArticle) {
            
            let vc = PodcastArticleVC()
            vc.isModalInPresentation = true
            vc.podcastArticleVCBackTapped = {
                if self.isAudioReadyToPlay {
                    
                    if !isUserProMember() {
                        
                        DispatchQueue.main.async {
                            self.dismiss(animated: true)
                        }
                        
                    } else {
                        
                        // Start playback
                        self.player?.play()
                        self.player?.rate = 1.0
                        self.ButtonPlay.setImage(UIImage(named: "podcastPauseButtonIMG"), for: .normal)
                        
                    }
                    
                } else {
                    self.comeBackFromArticleAndPlay = true
                }
                
            }
            
            self.present(vc, animated: true)
            
        } else {
            print("comeBackFromArticleAndPlay = true")
            comeBackFromArticleAndPlay = true
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        trackView.layoutIfNeeded()
        if form == nil {
            form = ZHWaveformView(frame: trackView.bounds)
            guard let form = form else { return }
            form.beginningPartColor = lightAppColor!
            form.endPartColor = lightAppColor!
            form.wavesColor = UIColor(hexString: "FF76B7")!
            //            form.trackScale = 0.20
            form.waveformDelegate = self
            form.croppedDelegate = self
            trackView.addSubview(form)
            form.loadRandomWaveform()
            //            form.loadUrl(url: audioURL!)
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleWaveformPanGesture(_:)))
            form.addGestureRecognizer(panGesture)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleWaveformTapGesture(_:)))
            form.addGestureRecognizer(tapGesture)
            
        } else {
            form?.frame = trackView.bounds
        }
    }
    
    private func setupLoader() {
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        view.addSubview(loader)
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: ButtonPlay.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: ButtonPlay.centerYAnchor)
        ])
    }
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backButtonImg"),
            rightImage: UIImage(named: "infoIconPostCast")
        )
        if let customNavBarView = customNavBarView {
            customNavBarView.leftButtonTapped = {
                self.player?.pause()
                self.player = nil
                self.dismiss(animated: true)
            }
            self.view.addSubview(customNavBarView)
            customNavBarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                customNavBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                customNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                customNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                customNavBarView.heightAnchor.constraint(equalToConstant: 44),
            ])
            
            customNavBarView.rightButtonTapped = {
                var vc = PodcastArticleVC()
                vc.isModalInPresentation = true
                self.comeBackFromArticleAndPlay = false
                vc.podcastArticleVCBackTapped = {
                    if self.isAudioReadyToPlay {
                        // Start playback
                        self.player?.play()
                        self.player?.rate = 1.0
                        self.ButtonPlay.setImage(UIImage(named: "podcastPauseButtonIMG"), for: .normal)
                    } else {
                        self.comeBackFromArticleAndPlay = true
                    }
                    
                }
                self.present(vc, animated: true)
            }
            
        }
        
    }
    
    private func setupUI() {
        
        podCastImgView.translatesAutoresizingMaskIntoConstraints = false
        podCastImgView.contentMode = .scaleAspectFill
        podCastImgView.clipsToBounds = true
        podCastImgView.layer.cornerRadius = 16
        view.addSubview(podCastImgView)
        
        podcastTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        podcastTitleLabel.textAlignment = .left
        podcastTitleLabel.font = .mymediumSystemFont(ofSize: 18)
        podcastTitleLabel.textColor = appColor
        podcastTitleLabel.numberOfLines = 2
        
        view.addSubview(podcastTitleLabel)
        
        podcastCaptionLabel.translatesAutoresizingMaskIntoConstraints = false
        podcastCaptionLabel.textAlignment = .left
        podcastCaptionLabel.font = UIFont.systemFont(ofSize: 13)
        podcastCaptionLabel.textColor = lightAppColor
        podcastCaptionLabel.numberOfLines = 2
        
        view.addSubview(podcastCaptionLabel)
        
        trackView.translatesAutoresizingMaskIntoConstraints = false
        trackView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        trackView.backgroundColor = .clear
        view.addSubview(trackView)
        
        lblOverallDuration.translatesAutoresizingMaskIntoConstraints = false
        lblOverallDuration.textAlignment = .right
        lblOverallDuration.font = .mymediumSystemFont(ofSize: 12.pulse2Font())
        lblOverallDuration.text = "00:00"
        lblOverallDuration.textColor = appColor
        lblOverallDuration.widthAnchor.constraint(equalToConstant: 40.pulseWithFont(withInt: 50)).isActive = true
        view.addSubview(lblOverallDuration)
        
        lblcurrentText.translatesAutoresizingMaskIntoConstraints = false
        lblcurrentText.textAlignment = .left
        lblcurrentText.textColor = appColor
        lblcurrentText.font = .mymediumSystemFont(ofSize: 12.pulse2Font())
        lblcurrentText.text = "00:00"
        lblcurrentText.widthAnchor.constraint(equalToConstant: 40.pulseWithFont(withInt: 50)).isActive = true
        view.addSubview(lblcurrentText)
        
        ButtonPlay.translatesAutoresizingMaskIntoConstraints = false
        ButtonPlay.setImage(UIImage(named: "podcastPlayButtonIMG"), for: .normal)
        ButtonPlay.addTarget(self, action: #selector(ButtonPlayTapped), for: .touchUpInside)
        view.addSubview(ButtonBackWard)
        
        ButtonBackWard.translatesAutoresizingMaskIntoConstraints = false
        ButtonBackWard.setImage(UIImage(named: "podcastPlayPreviousButtonIMG"), for: .normal)
        ButtonBackWard.addTarget(self, action: #selector(ButtonbackwardTapped), for: .touchUpInside)
        view.addSubview(ButtonPlay)
        
        
        ButtonForward.translatesAutoresizingMaskIntoConstraints = false
        ButtonForward.setImage(UIImage(named: "podcastPlayNextButtonIMG"), for: .normal)
        ButtonForward.addTarget(self, action: #selector(ButtonForwardTapped), for: .touchUpInside)
        view.addSubview(ButtonForward)
        
        
        let stackView = UIStackView(arrangedSubviews: [lblcurrentText, trackView, lblOverallDuration])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fill
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            podCastImgView.topAnchor.constraint(equalTo: self.customNavBarView!.bottomAnchor, constant: 30),
            podCastImgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingTextFieldLeftRightPadding),
            podCastImgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingTextFieldLeftRightPadding),
            podCastImgView.heightAnchor.constraint(equalTo: podCastImgView.widthAnchor),
            
            podcastTitleLabel.topAnchor.constraint(equalTo: podCastImgView.bottomAnchor, constant: 25),
            podcastTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingTextFieldLeftRightPadding),
            podcastTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingTextFieldLeftRightPadding),
            
            podcastCaptionLabel.topAnchor.constraint(equalTo: podcastTitleLabel.bottomAnchor, constant: 5),
            podcastCaptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingTextFieldLeftRightPadding),
            podcastCaptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingTextFieldLeftRightPadding),
            
            
            stackView.topAnchor.constraint(equalTo: podcastCaptionLabel.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DeviceSize.onbordingTextFieldLeftRightPadding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DeviceSize.onbordingTextFieldLeftRightPadding),
            
            ButtonPlay.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            ButtonPlay.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 36),
            ButtonPlay.widthAnchor.constraint(equalToConstant: 60),
            ButtonPlay.heightAnchor.constraint(equalToConstant: 60),
            
            ButtonBackWard.widthAnchor.constraint(equalToConstant: 50),
            ButtonBackWard.heightAnchor.constraint(equalToConstant: 50),
            ButtonForward.widthAnchor.constraint(equalToConstant: 50),
            ButtonForward.heightAnchor.constraint(equalToConstant: 50),
            
            ButtonBackWard.rightAnchor.constraint(equalTo: ButtonPlay.leftAnchor, constant: -18),
            ButtonBackWard.centerYAnchor.constraint(equalTo: ButtonPlay.centerYAnchor),
            
            ButtonForward.leftAnchor.constraint(equalTo: ButtonPlay.rightAnchor, constant: 18),
            ButtonForward.centerYAnchor.constraint(equalTo: ButtonPlay.centerYAnchor),
        ])
        
    }
    
    func configAudioPlayer() {
        
        setupintialData()
        
        loader.startAnimating()
        ButtonPlay.isHidden = true
        
        
        if isAudioFileDownloaded() {
            guard let audioURL = getAudioFilePath() else {
                showError(message: "Invalid URL")
                loader.stopAnimating()
                ButtonPlay.isHidden = false
                return
            }
            audioIsFetched(audioURL: audioURL)
        } else {
            let googleDriveFileID = getGoogleDriveFileIDForLanguage()
            guard let audioURL = URL(string: "https://drive.google.com/uc?export=download&id=\(googleDriveFileID)") else {
                showError(message: "Invalid URL")
                return
            }
            
            downloadAudio(from: audioURL) { [weak self] localURL in
                DispatchQueue.main.async {
                    guard let self = self, let localURL = localURL else {
                        self?.showError(message: "Download failed")
                        return
                    }
                    self.audioIsFetched(audioURL: audioURL)
                }
            }
            
        }
        
    }
    
    func audioIsFetched(audioURL: URL) {
        
        let playerItem = AVPlayerItem(url: audioURL)
        player = AVPlayer(playerItem: playerItem)
        guard player != nil else {
            showError(message: "Player initialization failed")
            loader.stopAnimating()
            ButtonPlay.isHidden = false
            return
        }
        
        playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.finishedPlaying(_:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
    }
    
    private func getAudioFilePath() -> URL? {
        
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let currentLanguage = MultiLanguage.MultiLanguageConst.currentAppleLanguage()
        let fileName = "podcast_\(currentLanguage).mp3"
        return documentDirectory.appendingPathComponent(fileName)
        
    }
    
    private func isAudioFileDownloaded() -> Bool {
        
        guard let filePath = getAudioFilePath() else { return false }
        return FileManager.default.fileExists(atPath: filePath.path)
        
    }
    
    private func downloadAudio(from url: URL, completion: @escaping (URL?) -> Void) {
        
        guard let destinationURL = getAudioFilePath() else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.downloadTask(with: url) { location, response, error in
            guard let location = location, error == nil else {
                completion(nil)
                return
            }
            do {
                try FileManager.default.moveItem(at: location, to: destinationURL)
                completion(destinationURL)
            } catch {
                completion(nil)
            }
        }
        task.resume()
        
    }
    
    private func getGoogleDriveFileIDForLanguage() -> String {
        
        let currentLanguage = MultiLanguage.MultiLanguageConst.currentAppleLanguage()
        switch currentLanguage {
        case "en": return "1VYrq5HSha0_8nHtiR0UmwZ4Duy5lZbj6"
        case "de": return "10lwioKFlHbr-6NLzhRSU5Xqpbk1aqVbJ"
        default: return "1VYrq5HSha0_8nHtiR0UmwZ4Duy5lZbj6"
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if player?.currentItem?.status == .readyToPlay {
                addPlayerObservers()
                
                // Wait for playback to start
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(handlePlaybackStarted),
                    name: NSNotification.Name.AVPlayerItemPlaybackStalled,
                    object: player?.currentItem
                )
                
                DispatchQueue.main.async {
                    self.isAudioReadyToPlay = true
                    if self.comeBackFromArticleAndPlay {
                        // Start playback
                        self.player?.play()
                        self.player?.rate = 1.0
                        self.ButtonPlay.setImage(UIImage(named: "podcastPauseButtonIMG"), for: .normal)
                        
                    }
                }
            } else if player?.currentItem?.status == .failed {
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
                    self.ButtonPlay.isHidden = true
                    self.showError(message: "Failed to load audio")
                }
            }
        }
    }
    
    @objc private func handlePlaybackStarted() {
        guard let player = player else { return }
        if player.rate > 0 {
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                self.ButtonPlay.isHidden = false
            }
        }
    }
    
    
    func addPlayerObservers() {
        guard let player = player else { return }
        
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }
            if let playerItem = self.player?.currentItem, playerItem.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(time)
                let totalTime = CMTimeGetSeconds(playerItem.duration)
                
                self.lblcurrentText.text = self.stringFromTimeInterval(interval: currentTime)
                self.lblOverallDuration.text = self.stringFromTimeInterval(interval: totalTime)
                
                let progress = CGFloat(currentTime / totalTime)
                self.form?.updateWaveform(forPlaybackPosition: progress)
            }
        }
        
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 10), queue: .main) { [weak self] _ in
            guard let self = self else { return }
            if self.player?.rate ?? 0 > 0 {
                self.loader.stopAnimating()
                self.ButtonPlay.isHidden = false
            }
        }
        
    }
    
    func isConnectedToInternet() -> Bool {
        let monitor = NWPathMonitor()
        let semaphore = DispatchSemaphore(value: 0)
        var isConnected = false
        
        monitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            semaphore.signal()
        }
        
        let queue = DispatchQueue(label: "NetworkMonitorQueue")
        monitor.start(queue: queue)
        semaphore.wait() // Wait until the check is done
        monitor.cancel()
        
        return isConnected
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func playerItemFailedToPlayToEndTime(_ notification: Notification) {
        if let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? NSError {
            print("Error during playback: \(error.localizedDescription)")
            showError(message: "Playback failed: \(error.localizedDescription)")
        }
    }
    
    func setupintialData(){
        podCastImgView.image = UIImage(named: "podcastThumbnail")
        podcastTitleLabel.text = "PodcastsVC.audioHeadlineLabel.text"~
        podcastCaptionLabel.text = "PodcastsVC.audioSubtitleLabel.text"~
    }
    
    @objc func handleWaveformPanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: form)
        let waveformWidth = form!.bounds.width
        let positionRatio = min(max(location.x / waveformWidth, 0), 1)
        let duration = CMTimeGetSeconds(player?.currentItem?.duration ?? CMTime.zero)
        let targetTime = CMTime(seconds: Double(positionRatio) * duration, preferredTimescale: 1)
        
        switch gesture.state {
        case .began, .changed:
            player?.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero)
            let playbackPosition = CGFloat(positionRatio)
            form!.updateWaveform(forPlaybackPosition: playbackPosition)
            lblcurrentText.text = stringFromTimeInterval(interval: CMTimeGetSeconds(targetTime))
        case .ended:
            if player?.rate == 0 {
                player?.play()
                player?.rate = 1.0
                ButtonPlay.setImage(UIImage(named: "podcastPauseButtonIMG"), for: .normal)
            }
        default:
            break
        }
    }
    
    @objc func handleWaveformTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let form = form, let player = player else { return }
        
        let location = gesture.location(in: form)
        let waveformWidth = form.bounds.width
        let positionRatio = min(max(location.x / waveformWidth, 0), 1)
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime.zero)
        let targetTime = CMTime(seconds: Double(positionRatio) * duration, preferredTimescale: 1)
        
        // Seek the player to the target time
        player.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero)
        
        // Update the waveform and current time label
        let playbackPosition = CGFloat(positionRatio)
        form.updateWaveform(forPlaybackPosition: playbackPosition)
        lblcurrentText.text = stringFromTimeInterval(interval: CMTimeGetSeconds(targetTime))
    }
    
    func waveformView(startCropped waveformView: ZHWaveformView) -> UIView? {
        let start = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        start.backgroundColor = .clear
        start.layer.borderWidth = 1
        start.layer.borderColor = UIColor.clear.cgColor
        return start
    }
    
    func waveformView(startCropped: UIView, progress rate: CGFloat) {
        let seconds : Int64 = Int64(rate)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0
        {
            player?.play()
        }
        print("Left rate:", rate)
    }
    
    func waveformViewDrawComplete(waveformView: ZHWaveformView) {
        print("fetched")
    }
    
    @objc private func ButtonPlayTapped() {
        guard let player = player else { return }
        
        if player.rate == 0 { // Player is paused
            player.play()
            player.rate = 1.0
            ButtonPlay.setImage(UIImage(named: "podcastPauseButtonIMG"), for: .normal)
        } else { // Player is playing
            player.pause()
            ButtonPlay.setImage(UIImage(named: "podcastPlayButtonIMG"), for: .normal)
        }
    }
    
    @objc private func ButtonbackwardTapped() {
        if let player = player{
            let currentTime = CMTimeGetSeconds(player.currentTime())
            if currentTime > 2.0{
                player.seek(to: .zero)
                if player.rate == 0
                {
                    player.play()
                    ButtonPlay.setImage(UIImage(named: "podcastPauseButtonIMG"), for: .normal)
                }
            }else{
                print("Previous podcast play")
            }
        }
    }
    
    @objc private func ButtonForwardTapped() {
        // next podcast
    }
    
    @objc private func finishedPlaying(_ myNotification: NSNotification) {
        player?.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
        
        ButtonPlay.setImage(UIImage(named: "podcastPlayButtonIMG"), for: .normal)
        
        form?.updateWaveform(forPlaybackPosition: 0.0)
        lblcurrentText.text = stringFromTimeInterval(interval: 0)
    }
    
    private func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
}
