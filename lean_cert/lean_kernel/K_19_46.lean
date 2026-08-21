import Sound
import lean_certs.cert_19_46

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H19_gt_46_kernel : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 19) (d := 46) (c := cert_19_46) (by decide)
