import Sound
import lean_certs.cert_22_42

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H22_gt_42_kernel : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 42 := by
  exact certValidRoot_sound (k := 22) (d := 42) (c := cert_22_42) (by decide)
