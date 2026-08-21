import Sound
import lean_certs.cert_27_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_100_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 27) (d := 100) (c := cert_27_100) (by decide)
