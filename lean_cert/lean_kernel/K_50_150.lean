import Sound
import lean_certs.cert_50_150

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_150_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 50) (d := 150) (c := cert_50_150) (by decide)
