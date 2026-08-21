import Sound
import lean_certs.cert_15_34

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H15_gt_34_kernel : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 34 := by
  exact certValidRoot_sound (k := 15) (d := 34) (c := cert_15_34) (by decide)
