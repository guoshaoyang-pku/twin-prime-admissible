import Sound
import lean_certs.cert_6_14

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H6_gt_14_kernel : ¬ ∃ t : List Nat, admissible 6 t = true ∧ diameter t ≤ 14 := by
  exact certValidRoot_sound (k := 6) (d := 14) (c := cert_6_14) (by decide)
