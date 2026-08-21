import Sound
import lean_certs.cert_18_40

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H18_gt_40_kernel : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 18) (d := 40) (c := cert_18_40) (by decide)
