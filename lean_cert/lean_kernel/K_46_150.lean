import Sound
import lean_certs.cert_46_150

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_150_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 46) (d := 150) (c := cert_46_150) (by decide)
