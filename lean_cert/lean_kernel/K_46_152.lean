import Sound
import lean_certs.cert_46_152

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_152_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 46) (d := 152) (c := cert_46_152) (by decide)
