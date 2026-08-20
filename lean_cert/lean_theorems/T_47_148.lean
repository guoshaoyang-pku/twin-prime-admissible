import Sound
import lean_certs.cert_47_148

open CertVerify

theorem H47_gt_148 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 47) (d := 148) (c := cert_47_148) (by native_decide)
