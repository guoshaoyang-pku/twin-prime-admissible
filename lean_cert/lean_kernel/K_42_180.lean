import Sound
import lean_certs.cert_42_180

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_180_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 42) (d := 180) (c := cert_42_180) (by decide)
