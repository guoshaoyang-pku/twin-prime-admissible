import Sound
import lean_certs.cert_35_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_100_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 35) (d := 100) (c := cert_35_100) (by decide)
