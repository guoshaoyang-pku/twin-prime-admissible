import Sound
import lean_certs.cert_28_66

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_66_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 28) (d := 66) (c := cert_28_66) (by decide)
