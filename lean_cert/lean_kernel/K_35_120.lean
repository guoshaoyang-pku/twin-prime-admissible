import Sound
import lean_certs.cert_35_120

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_120_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 35) (d := 120) (c := cert_35_120) (by decide)
