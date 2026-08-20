import Sound
import lean_certs.cert_47_186

open CertVerify

theorem H47_gt_186 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 47) (d := 186) (c := cert_47_186) (by native_decide)
