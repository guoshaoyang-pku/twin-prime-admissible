import Sound
import lean_certs.cert_14_42

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H14_gt_42_kernel : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 42 := by
  exact certValidRoot_sound (k := 14) (d := 42) (c := cert_14_42) (by decide)
