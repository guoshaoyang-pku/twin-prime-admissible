import Sound
import lean_certs.cert_35_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_94_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 35) (d := 94) (c := cert_35_94) (by decide)
