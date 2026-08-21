import Sound
import lean_certs.cert_47_186

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_186_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 47) (d := 186) (c := cert_47_186) (by decide)
