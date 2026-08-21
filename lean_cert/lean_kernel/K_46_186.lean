import Sound
import lean_certs.cert_46_186

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_186_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 46) (d := 186) (c := cert_46_186) (by decide)
