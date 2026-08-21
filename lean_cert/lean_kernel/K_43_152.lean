import Sound
import lean_certs.cert_43_152

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_152_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 43) (d := 152) (c := cert_43_152) (by decide)
