import Sound
import lean_certs.cert_35_150

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_150_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 35) (d := 150) (c := cert_35_150) (by decide)
