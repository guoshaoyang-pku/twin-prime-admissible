import Sound
import lean_certs.cert_45_180

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_180_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 45) (d := 180) (c := cert_45_180) (by decide)
