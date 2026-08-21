import Sound
import lean_certs.cert_11_26

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H11_gt_26_kernel : ¬ ∃ t : List Nat, admissible 11 t = true ∧ diameter t ≤ 26 := by
  exact certValidRoot_sound (k := 11) (d := 26) (c := cert_11_26) (by decide)
