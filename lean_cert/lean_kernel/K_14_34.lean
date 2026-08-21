import Sound
import lean_certs.cert_14_34

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H14_gt_34_kernel : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 34 := by
  exact certValidRoot_sound (k := 14) (d := 34) (c := cert_14_34) (by decide)
