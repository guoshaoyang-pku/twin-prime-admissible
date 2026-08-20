import Sound
import lean_certs.cert_47_210

open CertVerify

theorem H47_gt_210 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 210 := by
  exact certValidRoot_sound (k := 47) (d := 210) (c := cert_47_210) (by native_decide)
