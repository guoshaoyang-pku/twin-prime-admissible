import Sound
import lean_certs.cert_47_134

open CertVerify

theorem H47_gt_134 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 47) (d := 134) (c := cert_47_134) (by native_decide)
