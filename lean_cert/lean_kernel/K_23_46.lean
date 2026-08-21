import Sound
import lean_certs.cert_23_46

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H23_gt_46_kernel : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 23) (d := 46) (c := cert_23_46) (by decide)
