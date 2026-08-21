import Sound
import lean_certs.cert_18_42

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H18_gt_42_kernel : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 42 := by
  exact certValidRoot_sound (k := 18) (d := 42) (c := cert_18_42) (by decide)
