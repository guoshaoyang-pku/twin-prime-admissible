import Sound
import lean_certs.cert_39_180

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H39_gt_180_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 39) (d := 180) (c := cert_39_180) (by decide)
