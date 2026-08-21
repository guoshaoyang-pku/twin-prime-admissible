import Sound
import lean_certs.cert_34_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_72_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 34) (d := 72) (c := cert_34_72) (by decide)
