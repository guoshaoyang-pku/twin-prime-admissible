import Sound
import lean_certs.cert_47_220

open CertVerify

theorem H47_gt_220 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 220 := by
  exact certValidRoot_sound (k := 47) (d := 220) (c := cert_47_220) (by native_decide)
