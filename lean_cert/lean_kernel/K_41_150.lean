import Sound
import lean_certs.cert_41_150

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_150_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 41) (d := 150) (c := cert_41_150) (by decide)
