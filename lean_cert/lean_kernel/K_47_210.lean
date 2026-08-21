import Sound
import lean_certs.cert_47_210

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H47_gt_210_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 210 := by
  exact certValidRoot_sound (k := 47) (d := 210) (c := cert_47_210) (by decide)
