import Sound
import lean_certs.cert_40_150

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_150_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 40) (d := 150) (c := cert_40_150) (by decide)
