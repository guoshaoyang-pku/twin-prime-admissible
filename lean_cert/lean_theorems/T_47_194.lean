import Sound
import lean_certs.cert_47_194

open CertVerify

theorem H47_gt_194 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 47) (d := 194) (c := cert_47_194) (by native_decide)
