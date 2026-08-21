import Sound
import lean_certs.cert_35_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_72_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 35) (d := 72) (c := cert_35_72) (by decide)
