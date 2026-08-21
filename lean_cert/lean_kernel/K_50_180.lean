import Sound
import lean_certs.cert_50_180

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_180_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 50) (d := 180) (c := cert_50_180) (by decide)
