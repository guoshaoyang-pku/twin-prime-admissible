import Sound
import lean_certs.cert_42_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_88_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 42) (d := 88) (c := cert_42_88) (by decide)
