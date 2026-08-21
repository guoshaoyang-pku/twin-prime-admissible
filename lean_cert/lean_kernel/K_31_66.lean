import Sound
import lean_certs.cert_31_66

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_66_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 31) (d := 66) (c := cert_31_66) (by decide)
