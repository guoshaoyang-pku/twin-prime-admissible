import Sound
import lean_certs.cert_18_34

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H18_gt_34_kernel : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 34 := by
  exact certValidRoot_sound (k := 18) (d := 34) (c := cert_18_34) (by decide)
