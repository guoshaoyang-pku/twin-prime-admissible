import Sound
import lean_certs.cert_27_60

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_60_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 27) (d := 60) (c := cert_27_60) (by decide)
