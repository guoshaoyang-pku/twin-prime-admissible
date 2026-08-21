import Sound
import lean_certs.cert_11_34

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H11_gt_34_kernel : ¬ ∃ t : List Nat, admissible 11 t = true ∧ diameter t ≤ 34 := by
  exact certValidRoot_sound (k := 11) (d := 34) (c := cert_11_34) (by decide)
