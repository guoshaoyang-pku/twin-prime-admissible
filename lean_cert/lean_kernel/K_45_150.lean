import Sound
import lean_certs.cert_45_150

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_150_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 45) (d := 150) (c := cert_45_150) (by decide)
