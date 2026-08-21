import Sound
import lean_certs.cert_35_90

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_90_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 35) (d := 90) (c := cert_35_90) (by decide)
