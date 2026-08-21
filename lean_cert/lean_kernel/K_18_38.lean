import Sound
import lean_certs.cert_18_38

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H18_gt_38_kernel : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 38 := by
  exact certValidRoot_sound (k := 18) (d := 38) (c := cert_18_38) (by decide)
