import Sound
import lean_certs.cert_47_194

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_194_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 47) (d := 194) (c := cert_47_194) (by decide)
