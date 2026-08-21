import Sound
import lean_certs.cert_42_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_94_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 42) (d := 94) (c := cert_42_94) (by decide)
