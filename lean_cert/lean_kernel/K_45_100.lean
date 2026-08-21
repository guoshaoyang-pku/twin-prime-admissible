import Sound
import lean_certs.cert_45_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_100_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 45) (d := 100) (c := cert_45_100) (by decide)
