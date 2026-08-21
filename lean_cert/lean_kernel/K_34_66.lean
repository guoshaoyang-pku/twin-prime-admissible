import Sound
import lean_certs.cert_34_66

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_66_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 34) (d := 66) (c := cert_34_66) (by decide)
