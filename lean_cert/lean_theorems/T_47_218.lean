import Sound
import lean_certs.cert_47_218

open CertVerify

theorem H47_gt_218 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 218 := by
  exact certValidRoot_sound (k := 47) (d := 218) (c := cert_47_218) (by native_decide)
