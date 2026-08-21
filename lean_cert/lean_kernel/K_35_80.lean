import Sound
import lean_certs.cert_35_80

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_80_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 35) (d := 80) (c := cert_35_80) (by decide)
