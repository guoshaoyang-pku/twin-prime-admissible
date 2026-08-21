import Sound
import lean_certs.cert_39_150

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_150_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 39) (d := 150) (c := cert_39_150) (by decide)
