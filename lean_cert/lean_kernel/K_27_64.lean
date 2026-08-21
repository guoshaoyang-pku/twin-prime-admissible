import Sound
import lean_certs.cert_27_64

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_64_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 27) (d := 64) (c := cert_27_64) (by decide)
